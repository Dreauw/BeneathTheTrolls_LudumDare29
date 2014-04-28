package utils.gui {
	import flash.display.Shape;
	import flash.filters.BevelFilter;
	import flash.filters.BlurFilter;
	import flash.filters.ConvolutionFilter;
	import flash.filters.DropShadowFilter;
	import flash.filters.GlowFilter;
	import flash.text.StyleSheet;
	import net.flashpunk.Entity;
	import net.flashpunk.graphics.Graphiclist;
	import net.flashpunk.graphics.Image;
	import flash.geom.Matrix;
	import flash.display.GradientType;
	import net.flashpunk.graphics.Text;
	import net.flashpunk.utils.Input;
	import net.flashpunk.FP;
	import flash.filters.BitmapFilterQuality;
	import flash.display.BlendMode;
	public class Button extends Entity {
		private var _text:Text;
		private var func:Function;
		private var overFunc:Function;
		private var focused:Boolean = false;
		private var content:Image;
		private var border:Image;
		private var color:uint;
		private var style:uint = 0;
		public function Button(x:Number = 0, y:Number = 0, label:String = "", func:Function = null, overFunc:Function = null, color:uint = 0xFFFFFF, style:uint = 0, size:Number = 8, _width:Number = 0, _height:Number = 0) {
			this.func = func;
			this.overFunc = overFunc;
			this.color = color;
			this.style = style;
			_text = new Text(label, 0, 0, { size:size, outlineColor:0, outlineSize:1  } );
			_text.centerOrigin();
			_text.originX += 1;
			_text.originY += 1;
			if (_width == 0 && _height == 0) {
				setHitbox(_text.width + 4, _text.height, -5, -5);
			} else {
				setHitbox(_width, _height, -5, -5);
			}
			var shape:Shape = new Shape();
			if (style > 2) {
				shape.graphics.beginFill(0x6E6E6E, 1)
				shape.graphics.drawRect(5, 5, width+5, height+5);
				shape.graphics.endFill();
				shape.graphics.beginFill(0xFFFFFF, 0.2)
				shape.graphics.drawRect(5, 5, width+5, (height)/2);
				shape.graphics.endFill();
			} else {
				var gradientBoxMatrix:Matrix = new Matrix();
				gradientBoxMatrix.createGradientBox(width, height, Math.PI/2, 0, 0);
				shape.graphics.beginGradientFill(GradientType.LINEAR, [0xA0A0A0,
				0x6E6E6E], [1, 1], [0, 255], gradientBoxMatrix);
				shape.graphics.drawRect(5, 5, width+5, height+5);
				shape.graphics.endFill();
			}
			content = Image.createFromShape(shape);
			shape.graphics.clear();
			
			switch (style) {
				case 0:
				case 3:
					shape.graphics.beginFill(0xFFFFFF, 0.2);
					shape.graphics.drawRect(5, 5, width, 1);
					shape.graphics.drawRect(5, 6, 1, height-1);
					shape.graphics.endFill();
					shape.graphics.beginFill(0, 0.2);
					shape.graphics.drawRect(5, 4+height, width-1, 1);
					shape.graphics.drawRect(4 + width, 5, 1, height);
					shape.graphics.endFill();
					_text.filters = [new GlowFilter(0x222222, 0.5, 2, 2, 20)];
					break;
				case 1:
				case 4:
					shape.filters = [new DropShadowFilter(1, 45, 0,1, 2, 2, 1)];
					shape.graphics.lineStyle(1, 0xFFFFFF, 1, true);
					shape.graphics.drawRect(5, 5, width, height);
					shape.graphics.endFill();
					break;
				case 2:
				case 5:
					shape.filters = [new GlowFilter(0, 1, 2, 2, 2)];
					shape.graphics.lineStyle(1, 0xFFFFFF, 1, true);
					shape.graphics.drawRect(5, 5, width, height);
					shape.graphics.endFill();
					break;
			}
			shape.width = width+10;
			shape.height = height + 10;
			centerText();
			
			border = Image.createFromShape(shape);
			super(x, y, content);
			addGraphic(border);
			addGraphic(_text);
		}
		
		public function get text():String { return _text.text; }
		public function set text(value:String):void {
			_text.text = value;
			centerText();
		}
		
		public function centerText():void {
			_text.centerOrigin();
			_text.originX += 1;
			_text.originY += 1;
			_text.x = width / 2 + 5;
			_text.y = height / 2 + 5;
		}
		
		override public function update():void {
			super.update();
			
			if (collidePoint(x, y, Input.mouseX, Input.mouseY)) {
				if (!focused) {
					content.color = color;
					if (style == 0) _text.color = border.color = content.color;
					focused = true;
					if (overFunc != null) overFunc.call(this, this, focused);
				}
			} else if (focused) {
				content.color = 0xFFFFFF;
				if (style == 0) _text.color = border.color = content.color;
				focused = false;
				if (overFunc != null) overFunc.call(this, this, focused);
			}
			
			if (Input.mousePressed && focused) {
				if (func != null) func.call(this, this);
			}
		}
		
	}

}