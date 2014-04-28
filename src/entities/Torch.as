package entities {
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.FP;
	import flash.filters.BlurFilter;
	import net.flashpunk.graphics.Spritemap;
	import utils.Assets;

	public class Torch extends Entity {
		private var timer:Number = 0;
		private var radius:int = 0;
		public function Torch(x:Number, y:Number) {
			super(x, y);
			radius = 20;
			this.layer = 1;
			var anim:Spritemap = new Spritemap(Assets.TORCH, 9, 15);
			anim.add("normal", [0, 1, 2, 3, 2, 1], 5, true);
			anim.play("normal");
			addGraphic(anim);
			var img:Image = Image.createCircle(20, 0xEFE4B0, 0.05);
			img.filters = [new BlurFilter()];
			img.originX = 20 - anim.width / 2;
			img.originY = img.height / 2 - anim.height / 2;
			addGraphic(img);
			setHitbox(40, 40, img.originX, img.originY);
		}
		
	}

}