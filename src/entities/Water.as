package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;

	public class Water extends Entity{
		
		public function Water(x:Number, y:Number) {
			super(x, y, new Image(Assets.WATER), new Hitbox(16, 16));
			(graphic as Image).alpha = 0.3;
			layer = 5;
			type = "water";
		}
	}

}