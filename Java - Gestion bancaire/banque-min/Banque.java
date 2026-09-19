import java.util.ArrayList;
import java.util.List;

public class Banque {

    private List<Compte> comptes = new ArrayList<>();

    public void ajouterCompte(Compte compte) {
        comptes.add(compte);
    }

    public List<Compte> getComptes() {
        return comptes;
    }

    public Compte getCompte(int index) {
        return comptes.get(index);
    }

    public void afficherComptes() {
        for (int i = 0; i < comptes.size(); i++) {
            System.out.println((i + 1) + ". " + comptes.get(i));
        }
    }
}
