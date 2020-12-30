# System Operations
import os
import sys

# File Handling
import pandas as pd

# Math and Plotting
import numpy as np
from scipy.io import loadmat
from scipy.signal import spectrogram
import matplotlib.pyplot as plt

# Dataset
import torch
from torch.utils.data import Dataset

class ProtoDataset(Dataset):
    @property
    def raw_dirs(self):
        raise NotImplementedError

    @property
    def processed_dirs(self):
        raise NotImplementedError

    def is_processed(self):
        raise NotImplementedError

    def process_step(self):
        raise NotImplementedError

    def process(self):
        raise NotImplementedError

    def load(self):
        raise NotImplementedError

    def __init__(self, root):
        self.root = root
        self.processed_files = []
        self.labels = []
        if(not self.is_processed()):
            self.process()
        self.load()

    def __len__(self):
        return len(self.processed_files)

class PhysioNetDataset(ProtoDataset):
    @property
    def raw_dirs(self):
        return ["training2017"]

    @property
    def processed_dirs(self):
        return ["training", "testing"]

    def is_processed(self):
        is_processed = False
        for processed_dir in self.processed_dirs:
            if(os.path.exists(os.path.join(self.root, processed_dir))):
                is_processed = True
        return is_processed

    def process_step(self, signal):
         _, _, sxx = spectrogram(signal, self.fs)
         return sxx

    def process(self):
        print("Processing...")
        for processed_dir in self.processed_dirs:
            if(not os.path.exists(os.path.join(self.root, processed_dir))):
                os.mkdir(os.path.join(self.root, processed_dir))
        df = pd.read_csv(self.meta, names = ["Names", "Labels"])
        df.dropna()
        df.set_index("Names", inplace = True)
        count = 0
        for raw_dir in self.raw_dirs:
            for raw_file in os.listdir(os.path.join(self.root, raw_dir)):
                name, ext = raw_file.split('.')
                if("mat" == ext):
                    label = self.encoding[df.loc[name].item()]
                    if(0 == label or 1 == label):
                        signal = loadmat(os.path.join(self.root, raw_dir, raw_file))["val"]
                        if(9000 == signal.shape[-1]):
                            sxx = self.process_step(signal)
                            if(0 == (count%int(1/self.test_fraction))):
                                torch.save(torch.FloatTensor(sxx), os.path.join(self.root, self.processed_dirs[1], raw_file))
                            else:
                                torch.save(torch.FloatTensor(sxx), os.path.join(self.root, self.processed_dirs[0], raw_file))
                            count += 1
        print("Done!")

    def load(self):
        df = pd.read_csv(self.meta, names = ["Names", "Labels"])
        df.dropna()
        df.set_index("Names", inplace = True)
        if(self.training):
            for processed_file in os.listdir(os.path.join(self.root, self.processed_dirs[0])):
                name, _ = processed_file.split('.')
                label = self.encoding[df.loc[name].item()]
                self.processed_files.append(os.path.join(self.root, self.processed_dirs[0], processed_file))
                self.labels.append(label)
        else:
            for processed_file in os.listdir(os.path.join(self.root, self.processed_dirs[1])):
                name, _ = processed_file.split('.')
                label = self.encoding[df.loc[name].item()]
                self.processed_files.append(os.path.join(self.root, self.processed_dirs[1], processed_file))
                self.labels.append(label)

    def __init__(self, root, meta, fs, seconds, train = True):
        self.meta = meta
        self.encoding = {'N' : 0, 'A' : 1, 'O' : 2, 'P' : 3, '~' : 4} # Normal, Atrial Fibrillation, Other, Noisy
        self.fs = fs
        self.seconds = seconds
        self.training = train
        self.test_fraction = 0.20
        super().__init__(root)

    def __getitem__(self, idx):
        return torch.load(self.processed_files[idx]), self.labels[idx]