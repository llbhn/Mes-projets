public class CompteEpargne extends Compte implements Remunerable {

    private double tauxInteret = 3.0;

    public CompteEpargne(Client titulaire, double soldeInitial) {
        super(titulaire, soldeInitial);
    }

    @Override
    public void retirer(double montant) throws MontantInvalideException, SoldeInsuffisantException {
        if (montant <= 0) {
            throw new MontantInvalideException("Le montant doit être positif.");
        }
        if (montant > solde) {
            throw new SoldeInsuffisantException("Solde insuffisant sur ce compte.");
        }
        solde -= montant;
        transactions.add(new Transaction("Retrait", montant, solde));
    }

    @Override
    public String getTypeCompte() {
        return "Compte épargne";
    }

    @Override
    public double getTauxInteret() {
        return tauxInteret;
    }

    @Override
    public void appliquerInterets() {
        double interets = solde * tauxInteret / 100;
        solde += interets;
        transactions.add(new Transaction("Intérêts", interets, solde));
    }
}
