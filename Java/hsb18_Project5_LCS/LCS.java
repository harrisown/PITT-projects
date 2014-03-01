public class LCS {
	public static char[] word1;
	public static char[] word2;
	public static int[][] memo;
	public static int[][] topmemo;
	
	public static void findLCS(String w1, String w2) {
		int word1length = w1.length();
		int word2length = w2.length();
		word1 = w1.toCharArray();
		word2 = w2.toCharArray();
		memo = new int[w1.length() + 1][w2.length() + 1];
		topmemo = new int[word1length+1][word2length+1];
		int lcs_length = topDownLCS(word1length-1,word2length-1);
		
		System.out.println("\nLength of LCS is "+lcs_length);
		// bottom up solution to dynamic programming problem easier for printing
		for (int i = word1length - 1; i >= 0; i--) {
			for (int j = word2length - 1; j >= 0; j--) {
				if (word1[i] == word2[j]) {
					memo[i][j] = memo[i + 1][j + 1] + 1;
				} else {
					memo[i][j] = Math.max(memo[i + 1][j], memo[i][j + 1]);
				}
			}
		}
		StringBuilder sb = new StringBuilder();
		int i = 0;
		int j = 0;
		while (i < word1length && j < word2length) {
			if (word1[i] == word2[j]) {
				sb.append(word1[i]);
				i++;
				j++;
			} else if (memo[i + 1][j] >= memo[i][j + 1]) {
				i++;
			} else
				j++;
		}
		
		System.out.println("LCS is:"+sb.toString());

	}
	public static int topDownLCS(int i, int j) {
		if (i == 0){
			return 1;
		}
		if(j == 0){
			return 1;
		}
		if (topmemo[i][j] != 0) {
			return topmemo[i][j];
		}
		if (word1[i] == word2[j]) {
			int result = topDownLCS((i - 1), (j - 1)) + 1;
			topmemo[i][j] = result;
			return result;
		} else {
			int max = Math.max(topDownLCS(i, (j - 1)), topDownLCS((i - 1), j));
			topmemo[i][j] = max;
			return max;
		}
	}

}