import java.util.Scanner;

public class RockPaperScissor {
    public static void main(String[]args) {
        System.out.println("Start game");
        System.out.println(gameplay());
    }
    public static String randomPlaying(int randomchoice){
        String opponent;
        if(randomchoice == 1){
            opponent = "Rock";
        }else if(randomchoice == 2){
            opponent = "Paper";
        }
        else{
            opponent = "Scissors";
        }
        return opponent;
    }
    public static String PlayerPlay(int PlayerInt) {
        String player;
        if(PlayerInt == 1){
            player = "Rock";
        }else if(PlayerInt == 2){
            player = "Paper";
        }else{
            player = "Scissors";
        }
        return player;
    }
    public static String Playerwin(String player, String opponent){
        String result;
        if(player == opponent){
            result = "TIE";
        }else if(player == "Rock" && opponent == "Scissors"){
            result = "PLAYER WIN";
        }
        else if(player == "Scissors" && opponent == "Paper"){
            result = "PLAYER WIN";
        }
        else if(player == "Paper" && opponent == "Rock"){
            result = "PLAYER WIN";
        }else{
            result = "PLAYER LOSE";
        }
        return result;
    }
    public static String gameplay(){
        String playerchoice, opponentchoice;
        Scanner Playerscn = new Scanner(System.in);
        System.out.println("1 for Rock \n2 for Paper \n3 for Scissors");
        int inputnum = Playerscn.nextInt();
        playerchoice = PlayerPlay(inputnum);
        Playerscn.close();
        if(inputnum> 3){
            System.out.println("Option not valid");
        }else{
            System.out.println("Player : "+playerchoice);
        }
        opponentchoice = randomPlaying((int)(Math.random()*3 + 1));
        System.out.println("Opponent : "+opponentchoice);
        String WinLose = Playerwin(playerchoice,opponentchoice);
        return WinLose;
    }
}
