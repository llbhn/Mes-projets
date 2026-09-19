public interface Operable {

    void deposer(double montant) throws MontantInvalideException;

    void retirer(double montant) throws MontantInvalideException, SoldeInsuffisantException;

    double getSolde();
}
