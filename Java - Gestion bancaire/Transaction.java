public class Transaction {

    private String type;
    private double montant;
    private double soldeApres;

    public Transaction(String type, double montant, double soldeApres) {
        this.type = type;
        this.montant = montant;
        this.soldeApres = soldeApres;
    }

    @Override
    public String toString() {
        return type + " : " + montant + " EUR (solde apres : " + soldeApres + " EUR)";
    }
}
