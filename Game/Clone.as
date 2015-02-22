package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.filters.*;
	
	public final class Clone extends MovieClip {
		
		public function Initialize (playerY:Number) {
			width = GameData.avatarSize.x;
			height = GameData.avatarSize.y;
			
			var blur:BlurFilter = new BlurFilter ();
			blur.blurX = 16;
			blur.blurY = blur.blurX;
			filters = [blur];
			
			var ct:ColorTransform = new ColorTransform ();
			ct.color = 0x333333;
			transform.colorTransform = ct;
			
			x = -Math.random () * 300 - 50;
			y = playerY + Math.random () * 100 - 50;
		}
		
		public function Activate () {
			play ();
		}
		
		public function Deactivate () {
			stop ();
		}
		
		public function PrepareToDie () {
			Deactivate ();
			filters = [];
		}
	}
}