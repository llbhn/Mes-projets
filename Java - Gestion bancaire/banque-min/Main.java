public class Main {

    public static void main(String[] args) {
        Banque banque = new Banque();

        Client Peter = new Client("Parker", "Peter", "spider.man@gmail.com");
        Client Emrys = new Client("Le Gall", "Emrys", "em.legall@gmail.com");

        banque.ajouterCompte(new CompteCourant(Peter, 1200.0));
        banque.ajouterCompte(new CompteEpargne(Emrys, 5000.0));
        banque.ajouterCompte(new CompteCourant(Emrys, 450.0));

        MenuConsole menu = new MenuConsole(banque);
        menu.demarrer();
    }
}
