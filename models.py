class Trainer():
    def __init__(self, model, loss, optim):
        self.model = model
        self.loss = loss
        self.optim = optim

    def train_step(self, train_loader):
        if(self.model.training):
            loss = 0.0
            for batch_idx, batch_data in enumerate(train_loader):
                data, batch_labels = batch_data
                self.optim.zero_grad()
                batch_probs = softmax(self.model(data), dim = -1)
                batch_probs = torch.squeeze(batch_probs, dim = 1)
                batch_probs = torch.squeeze(batch_probs, dim = 1)
                batch_loss = self.loss(batch_probs, batch_labels)
                batch_loss.backward()
                self.optim.step()
                loss += batch_loss
            return loss/len(train_loader)
        else:
            sys.error("Set model.training to True.")
    
    def test_step(self, test_loader):
        if(not self.model.training):
            labels = []
            max_probs = []
            preds = []
            for batch_idx, batch_data in enumerate(test_loader):
                data, batch_labels = batch_data
                batch_probs = softmax(self.model(data), dim = -1)
                batch_probs = torch.squeeze(batch_probs, dim = 1)
                batch_probs = torch.squeeze(batch_probs, dim = 1)
                batch_max_probs, batch_preds = torch.max(batch_probs, dim = -1)
                for label in batch_labels:
                    labels.append(label)
                for max_prob in batch_max_probs:
                    max_probs.append(max_prob.detach().numpy())
                for pred in batch_preds:
                    preds.append(pred)
            tn, fp, fn, tp = confusion_matrix(labels, preds).ravel()
            fpr, tpr, _ = roc_curve(labels, max_probs)
            auc = roc_auc_score(labels, max_probs)
            return tn, fp, fn, tp, tpr, fpr, auc
        else:
            sys.error("Set model.training to False.")
            
    def train(self, train_loader, epochs, verbose = False):
        self.model.training = True
        loss_list = []
        for i in range(epochs):
            loss = self.train_step(train_loader)
            loss_list.append(loss)
            if(verbose):
                print("Epoch: {:d}\tLoss: {:f}".format(i, loss))
        fig, ax = plt.subplots()
        ax.plot(np.arange(epochs), np.array(loss_list))
        ax.set_xlabel("Epoch")
        ax.set_ylabel("Loss")
        ax.set_title("Loss")
    
    def test(self, test_loader, verbose = True):
        self.model.training = False
        tn, fp, fn, tp, tpr, fpr, auc = self.test_step(test_loader)
        sens = tp/(tp + fn)
        spec = tn/(tn + fp)
        if(verbose):
            fig, ax = plt.subplots()
            ax.plot(fpr, tpr)
            ax.set_xlabel("False Positive Rate")
            ax.set_xlabel("True Positive Rate")
            ax.set_title("Confusion Matrix")
            print("Sensitivity: {:f}\tSpecificity: {:f}\tAUC: {:f}".format(sens, spec, auc))
        return sens, spec, auc