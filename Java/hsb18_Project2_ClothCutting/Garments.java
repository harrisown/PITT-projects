public class Garments{
	private int x;
	private int y;

	public Garments() {
	}

	public Garments(int x, int y){
		this.x = x;
		this.y = y;
	}

	public Garments(Garments garment) {
		this.x = garment.x;
		this.y = garment.y;
	}
	
}
