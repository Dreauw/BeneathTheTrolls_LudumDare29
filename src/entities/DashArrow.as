package entities {
	import flash.filters.GlowFilter;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import utils.Assets;
	import net.flashpunk.FP;
	import worlds.WorldGame;

	public class DashArrow extends Entity{
		private var img:Image;
		private var fixedOn:Player;
		
		public function DashArrow(fixedOn:Player) {
			super(fixedOn.x, fixedOn.y);
			this.fixedOn = fixedOn;
			img = new Image(Assets.ARROW);
			img.filters = [new GlowFilter(0xFFFFFF, 1, 3, 3, 1)];
			
			graphic = img;
			img.originX = 3;
			img.originY = 5;
			img.alpha = 0.1;
			layer = 6;
		}
		
		override public function update():void {
			super.update();
			this.visible = fixedOn.dashReloadTimer <= 0;
			this.x = fixedOn.x;
			this.y = fixedOn.y;
			img.angle = FP.angle(x, y, (world as WorldGame).getMouseX(), (world as WorldGame).getMouseY());
		}
		
		public function changeColor(color:uint) : void {
			img.color = color;
		}
		
	}

}