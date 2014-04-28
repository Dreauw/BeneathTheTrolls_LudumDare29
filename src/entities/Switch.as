package entities {
	import flash.filters.GlowFilter;
	import flash.geom.Rectangle;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import net.flashpunk.masks.Hitbox;
	import utils.Assets;
	import utils.Audio;
	
	public class Switch extends Entity{
		public var activated:Boolean = false;
		public var la:Boolean = false;
		private var sid:int;
		public function Switch(x:Number, y:Number, sid:int = 0) {
			super(x, y+11, new Image(Assets.SWITCH, new Rectangle(16 * sid, 0, 16, 5)), new Hitbox(16, 5));
			this.sid = sid;
			layer = 1;
			type = "switch" + sid;
			Audio.registerSound("switch", "0,,0.1374,,0.1542,0.5364,,,,,,,,0.0594,,,,,1,,,0.1,,0.5");
			Audio.registerSound("switch2", "0,,0.1959,,0.0397,0.2071,,,,,,,,0.507,,,,,1,,,0.1,,0.5");
		}
		
		override public function update():void {
			super.update();
			var t:Boolean = collide("bro", x, y) != null;
			activated = (t || collide("enemy", x, y));
			if (activated != la) {
				la = activated;
				if (t) Audio.playSound(la ? "switch" : "switch2");
			}
		}
		
		private function getSwitchBlock():Array {
			var a:Array = new Array();
			world.getClass(SwitchBlock, a);
			return a;
		}
	}

}