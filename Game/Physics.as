package Game {
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.*;
	
	public final class Physics extends Shape {
		private var player:Player;
		private var playerHits:Array = [];
		private var txtThought:TextField;
		private var objectCont:Sprite;
		private var spikes:Shape;
		private var topSpikes:Array;
		private var botSpikes:Array;
		private var maskCont:Sprite;
		
		public function SetPlayer (p:Player) {
			player = p;
			
			for (var i:int = 0; i < player.numChildren; i++) {
				var hit:* = player.getChildAt (i);
				
				if (hit is mcHit) {
					playerHits.push (hit);
				}
			}
		}
		
		public function SetThoughtTF (tf:TextField) {
			txtThought = tf;
		}
		
		public function SetObjectCont (cont:Sprite) {
			objectCont = cont;
		}
		
		public function SetSpikes (Spikes:Shape, top:Array, bot:Array) {
			spikes = Spikes;
			topSpikes = top;
			botSpikes = bot;
		}
		
		public function SetMaskCont (cont:Sprite) {
			maskCont = cont;
		}
		
		public function Update () {
			for (var i:int = 0; i < topSpikes.length; i++) {
				topSpikes [i].x -= GameData.worldSpeed;
				botSpikes [i].x -= GameData.worldSpeed;
			}
			
			if (player.rising) {
				if (player.ySpeed - GameData.gravity < -GameData.maxYSpeed) {
					player.ySpeed = -GameData.maxYSpeed;
				} else {
					player.ySpeed -= GameData.gravity;
				}
				
				if (player.rotation - GameData.rotateSpeed > -GameData.maxRotation) {
					player.rotation -= GameData.rotateSpeed;
				} else {
					player.rotation = -GameData.maxRotation;
				}
			} else {
				if (player.ySpeed + GameData.gravity > GameData.maxYSpeed) {
					player.ySpeed = GameData.maxYSpeed;
				} else {
					player.ySpeed += GameData.gravity;
				}
				
				if (player.rotation + GameData.rotateSpeed < GameData.maxRotation) {
					player.rotation += GameData.rotateSpeed;
				} else {
					player.rotation = GameData.maxRotation;
				}
			}
			
			player.y += player.ySpeed;
			MovieClip (maskCont.getChildAt (0)).y = player.y;
			
			txtThought.y = player.y - txtThought.height / 2;
			
			for (var i:int = 0; i < playerHits.length; i++) {
				var p:Point = playerHits [i].localToGlobal (new Point ());
				
				if (spikes.hitTestPoint (p.x, p.y, true)) {
					dispatchEvent (new GameEvent (GameEvent.PlayerHitSpikes));
				}
			}
			
			var pickedTreasures:Array = [];
			var objectsOffScreen:Array = [];
			
			for (var i:int = 0; i < objectCont.numChildren; i++) {
				var obj:* = objectCont.getChildAt (i);
				
				if (obj is Clone) {
					Clone (obj).x += GameData.cloneSpeed;
					
					if (Clone (obj).x > stage.stageWidth + 50) {
						objectsOffScreen.push (obj);
					}
				} else if (obj is Treasure) {
					Treasure (obj).x -= GameData.worldSpeed;
					Treasure (obj).theMask.x = Treasure (obj).x;
					
					for (var j:int = 0; j < playerHits.length; j++) {
						var p:Point = playerHits [j].localToGlobal (new Point ());
						
						if (Point.distance (p, new Point (Treasure (obj).x, Treasure (obj).y)) < Treasure (obj).width / 2) {
							pickedTreasures.push (obj);
							break;
						}
					}
					
					if (Treasure (obj).x + GameData.treasureLightSize < 0) {
						objectsOffScreen.push (obj);
					}
				} else if (obj is mcBubble) {
					MovieClip (obj).x -= GameData.worldSpeed + Math.random () * (GameData.maxBubbleSpeed);
					
					if (MovieClip (obj).x < -50) {
						objectsOffScreen.push (obj);
					}
				}
			}

			for (var i:int = 0; i < objectsOffScreen.length; i++) {
				dispatchEvent (new GameEvent (GameEvent.ObjectOffScreen, objectsOffScreen [i]));
			}
			
			for (var i:int = 0; i < pickedTreasures.length; i++) {
				dispatchEvent (new GameEvent (GameEvent.PickTreasure, pickedTreasures [i]));
			}
		}
	}
}