package Screener.BigScreens {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
    import flash.net.*;
	import Screener.*;
	
	public final class SplashScreen extends BaseScreen {

		public override function Initialize (arg:Object = null) {
			SoundManager.PlayMusic ();
			
			stage.addEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown, false, 0, true);
			addEventListener (Event.ENTER_FRAME, onFrame, false, 0, true);
		}

		public override function PrepareToDie () {
			stage.removeEventListener (MouseEvent.MOUSE_DOWN, onStageMouseDown);
			removeEventListener (Event.ENTER_FRAME, onFrame);
		}
		
		private function onStageMouseDown (e:MouseEvent) {
            if (currentLabel == "sponsor") {
                navigateToURL (new URLRequest ("http://www.myultimategames.com"));
            } else if (currentLabel == "developer") {
                navigateToURL (new URLRequest ("http://benjyap.99k.org"));    
            }

		}
		
		private function onFrame (e:Event) {
            if (currentFrame == totalFrames) {
    			screenMgr.NewBigScreen (ScreenType.Menu);
            }
		}
	}
}
