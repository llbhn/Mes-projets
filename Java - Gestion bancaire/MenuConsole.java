import java.util.Scanner;

public class MenuConsole {

    private Banque banque;
    private Scanner scanner = new Scanner(System.in);

    public MenuConsole(Banque banque) {
        this.banque = banque;
    }

    public void demarrer() {
        int choix = -1;

        while (choix != 0) {
            System.out.println("\n= MENU DE L'INCROYABLE BANQUE =");
            System.out.println("1. Afficher les comptes");
            System.out.println("2. Déposer de l'argent");
            System.out.println("3. Retirer de l'argent");
            System.out.println("4. Afficher l'historique d'un compte");
            System.out.println("5. Appliquer les intérêts (que sur les comptes épargne)");
            System.out.println("0. Quitter");
            System.out.print("Votre choix : ");
            choix = Integer.parseInt(scanner.nextLine());

            try {
                switch (choix) {
                    case 1:
                        banque.afficherComptes();
                        break;

                    case 2:
                        banque.afficherComptes();
                        System.out.print("Numéro du compte : ");
                        int i1 = Integer.parseInt(scanner.nextLine()) - 1;
                        System.out.print("Montant a déposer : ");
                        double montantDepot = Double.parseDouble(scanner.nextLine());
                        banque.getCompte(i1).deposer(montantDepot);
                        System.out.println("Dépôt effectué.");
                        break;

                    case 3:
                        banque.afficherComptes();
                        System.out.print("Numéro du compte : ");
                        int i2 = Integer.parseInt(scanner.nextLine()) - 1;
                        System.out.print("Montant a retirer : ");
                        double montantRetrait = Double.parseDouble(scanner.nextLine());
                        banque.getCompte(i2).retirer(montantRetrait);
                        System.out.println("Retrait effectué.");
                        break;

                    case 4:
                        banque.afficherComptes();
                        System.out.print("Numéro du compte : ");
                        int i3 = Integer.parseInt(scanner.nextLine()) - 1;
                        banque.getCompte(i3).afficherHistorique();
                        break;

                    case 5:
                        for (Compte c : banque.getComptes()) {
                            if (c instanceof Remunerable) {
                                ((Remunerable) c).appliquerInterets();
                            }
                        }
                        System.out.println("Intérêts appliqués.");
                        break;

                    case 0:
                        System.out.println("Salut !");
                        break;

                    default:
                        System.out.println("Choix invalide.");
                }
            } catch (MontantInvalideException | SoldeInsuffisantException e) {
                System.out.println("Erreur : " + e.getMessage());
            }
        }
    }
}
