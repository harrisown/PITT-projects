import java.util.ArrayList;
import java.util.Collections;

public class Combination {
	ArrayList<Integer> Pre = new ArrayList<Integer>();
	ArrayList<Integer> combo_ids = new ArrayList<Integer>();
	public double support;
	public double confidence;
	public boolean checked = false;

	public Combination(ArrayList<Integer> ids) {
		for (int i = 0; i < ids.size(); i++) {
			this.combo_ids.add(ids.get(i));
		}

	}


	public String toString() {
		StringBuilder sb = new StringBuilder();
		for (int i = 0; i < this.combo_ids.size(); i++) {
			sb.append(combo_ids.get(i) + " ");
		}
		sb.append("Support is " + support);
		return sb.toString();

	}
	
	

}
