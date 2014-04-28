package utils.gui {
	import flash.display.Shape;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Image;
	import flash.filters.GlowFilter;
	import net.flashpunk.FP;

	public class Bar extends Entity{
		private const BORDER_COLOR:uint = 0xFFFFFF;
		private const GLOW_COLOR:uint = 0;
		private var _value:Number = 0;
		private var bar:Image;
		public function Bar(x:Number, y:Number, width:Number, height:Number, color:uint, value:Number = -1) {
			setHitbox(width, height);
			var shape:Shape = new Shape();
			_value = value >= 0 ? value : width;
			shape.graphics.beginFill(0, 0.5);
			shape.graphics.drawRect(2, 2, width, height);
			shape.graphics.endFill();
			shape.filters = [new GlowFilter(GLOW_COLOR, 1, 2, 2, 2)];
			shape.graphics.lineStyle(1, BORDER_COLOR, 1, true);
			shape.graphics.drawRect(1, 1, width+1, height+1);
			shape.graphics.endFill();
			shape.width += 2;
			shape.height += 2;
			super(x, y, Image.createFromShape(shape));
			shape = new Shape();
			var height2:uint = Math.ceil(height / 4);
			shape.graphics.beginFill(color, 1);
			shape.graphics.drawRect(2, 2, width, height);
			shape.graphics.endFill();
			shape.graphics.beginFill(0xFFFFFF, 0.3);
			shape.graphics.drawRect(2, 2, width, height2);
			shape.graphics.endFill();
			shape.graphics.beginFill(0, 0.3);
			height2 = Math.floor(height / 4);
			shape.graphics.drawRect(2, height-height2+2, width, height2);
			shape.graphics.endFill();
			shape.width += 2;
			shape.height += 2;
			bar = Image.createFromShape(shape);
			bar.clipRect.width = _value;
			addGraphic(bar);
		}
		
		public function changeValue(value:Number, maxValue:Number, animation:Boolean = true) : void {
			_value = value / maxValue * width;
			if (!animation) {
				bar.clipRect.width = _value;
				bar.clear();
                bar.updateBuffer();
			}
		}
		
		override public function update():void {
			super.update();
			if (bar.clipRect.width != _value) {
				bar.clipRect.width += FP.sign(_value - bar.clipRect.width);
				bar.clear();
                bar.updateBuffer();
			}
		}
		
	}

}