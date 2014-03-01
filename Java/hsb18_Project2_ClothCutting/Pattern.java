
public class Pattern {
	public int width;
	public int height;
	public int value;
	public String name;
	
	public Pattern(int i, int j, int k, String string) {
		this.width = i;
		this.height = j;
		this.value = k;
		this.name = string;
		
	}
	public Pattern() {
		this.width = 0;
		this.height = 0;
		this.value = 0;
		this.name = "";
	}
	public String toString(){
		return "Width:"+this.width +"Height:"+this.height+"Name:"+this.name;
	}
	

}
