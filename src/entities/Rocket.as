package entities {
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import net.flashpunk.FP;
	import utils.Audio;

	public class Rocket extends Entity{
		private var img:Image;
		private var respawnTimer:Number = 0;
		public function Rocket(x:Number, y:Number) {
			super(x, y, null, new Hitbox(11, 15));
			this.layer = 1;
			img = new Image(Assets.ROCKET_BLUE);
			img.filters = [new GlowFilter(0xFFFFFF, 0.5)];
			graphic = img;
			Audio.registerSound("rocket", "0,,0.0288,0.5243,0.3426,0.8648,,,,,,0.4731,0.631,,,,,,1,,,,,0.5");
		}
		
		override public function update():void {
			super.update();
			if (respawnTimer > 0) {
				respawnTimer -= FP.elapsed;
				return;
			}
			this.visible = true;
			var p:Player = collide("bro", x, y) as Player;
			if (p) {
				if (this.isRemoved) return;
				Audio.playSound("rocket");
				for (var i:int = 0; i < 8; i++) {
					var sp:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
					sp.initialize(9, x, y, (i * 360 / 8), 30, 0.5);
				}
				p.addRocket();
				this.visible = false;
				respawnTimer = 2;
			}
		}
		
	}

}