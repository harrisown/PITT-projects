//////////////////////////////////////////////////////////////////////
///
/// Contents: Test LCS program.
/// Author:   John Aronis
/// Date:     April 2013
///
//////////////////////////////////////////////////////////////////////

public class TestLCS {

  public static void main(String[] args) {
    String word1, word2 ;
    word1 = "afasdfaalskdjfadjifajsdkfjalsdknfamdsnfnasdvnioavnionaiosdjfoiajsdiofjaiosjfioaejiofjaksdffe";
    word2 = "afalskdaflskdflajsdlkfjasdljfoajesijfiejfinanfmnmdsnfjanfnewifnienfaiesfjaojwef";
    System.out.print("LCS of " + word1 + " and " + word2 + ": ") ;
    //System.out.println( LCS.findLCS(word1,word2) ) ;
    LCS.findLCS(word1, word2);
  }

}

/// End-of-File