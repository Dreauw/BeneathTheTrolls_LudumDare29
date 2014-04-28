package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.graphics.Spritemap;
	import net.flashpunk.masks.Hitbox;
	import net.flashpunk.utils.Input;
	import net.flashpunk.utils.Key;
	import net.flashpunk.FP;
	import utils.Assets;
	import worlds.WorldGame;

	public class Platform extends Entity {
		
		public function Platform(x:Number, y:Number) {
			super(x, y);
			mask = new Hitbox(16, 3);
			layer = 1;
			graphic = new Image(Assets.PLATFORM);
			type = "platform";
		}
		
	}

}