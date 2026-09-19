import java.util.ArrayList;
import java.util.List;

public abstract class Compte implements Operable {

    private static int compteur = 1;

    private String numero;
    private Client titulaire;
    protected double solde;
    protected List<Transaction> transactions = new ArrayList<>();

    public Compte(Client titulaire, double soldeInitial) {
        this.numero = "compte" + compteur;
        compteur++;
        this.titulaire = titulaire;
        this.solde = soldeInitial;
    }

    @Override
    public void deposer(double montant) throws MontantInvalideException {
        if (montant <= 0) {
            throw new MontantInvalideException("Le montant doit être positif.");
        }
        solde += montant;
        transactions.add(new Transaction("Dépôt", montant, solde));
    }

    public abstract void retirer(double montant) throws MontantInvalideException, SoldeInsuffisantException;

    public abstract String getTypeCompte();

    public String getNumero() {
        return numero;
    }

    public Client getTitulaire() {
        return titulaire;
    }

    @Override
    public double getSolde() {
        return solde;
    }

    public void afficherHistorique() {
        System.out.println("Historique du compte " + numero + " ("+ getTypeCompte() +"):");
        for (Transaction t : transactions) {
            System.out.println("  " + t);
        }
    }

    @Override
    public String toString() {
        return numero + " - " + getTypeCompte() + " - " + titulaire + " - solde : " + solde + " eur";
    }
}
