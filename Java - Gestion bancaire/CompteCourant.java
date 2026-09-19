public class CompteCourant extends Compte {

    private double decouvertAutorise = 500.0;

    public CompteCourant(Client titulaire, double soldeInitial) {
        super(titulaire, soldeInitial);
    }

    @Override
    public void retirer(double montant) throws MontantInvalideException, SoldeInsuffisantException {
        if (montant <= 0) {
            throw new MontantInvalideException("Le montant doit être positif.");
        }
        if (solde - montant < -decouvertAutorise) {
            throw new SoldeInsuffisantException("Retrait refuser, découvert maximum atteint.");
        }
        solde -= montant;
        transactions.add(new Transaction("Retrait", montant, solde));
    }

    @Override
    public String getTypeCompte() {
        return "Compte courant";
    }
}
