package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.SyParticle;
	import net.flashpunk.FP;
	import utils.Audio;

	public class Rock extends Entity{
		public function Rock(x:Number, y:Number) {
			super(x, y, new Image(Assets.ROCK), new Hitbox(16, 16));
			layer = 2;
			type = "solid";
			Audio.registerSound("rock", "3,,0.1573,0.2945,0.055,0.0868,,0.0993,,,,,,,,,-0.2199,-0.0331,1,,,,,0.5");
		}
		
		override public function update():void {
			super.update();
			moveBy(0, 2, "solid");
		}
		
		public function destroy():void {
			if (this.isRemoved) return;
			Audio.playSound("rock");
			for (var i:int = 0; i < 4; i++) {
				var p:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
				p.initialize(FP.choose(3, 4), x + width / 2, y + height / 2, (i*360/4), 30, 0.5);
			}
			
			world.remove(this);
		}
	}

}