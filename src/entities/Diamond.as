package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import worlds.WorldGame;
	import utils.Audio;

	public class Diamond extends Entity{
		
		public function Diamond(x:Number, y:Number) {
			super(x+4, y+4, new Image(Assets.DIAMOND), new Hitbox(8, 8));
			(graphic as Image).filters = [new GlowFilter(0xFFFFFF, 0.8)];
			layer = 2;
			Audio.registerSound("diamond", "0,,0.0365,0.3957,0.3104,0.6458,,,,,,,,,,,,,1,,,,,0.5");
		}
		
		override public function update():void {
			super.update();
			if (collide("bro", x, y)) {
				if (this.isRemoved) return;
		
				Audio.playSound("diamond");
				for (var i:int = 0; i < 8; i++) {
					var p:SimpleParticle = world.create(SimpleParticle) as SimpleParticle;
					p.initialize(9, x, y, (i * 360 / 8), 30, 0.5);
				}
				world.remove(this);
				(world as WorldGame).score += 10;
			}
		}
	}

}