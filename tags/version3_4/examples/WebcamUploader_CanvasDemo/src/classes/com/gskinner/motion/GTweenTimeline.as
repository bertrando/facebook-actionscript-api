﻿/*** GTweenTimeline by Grant Skinner. Jan 15, 2009* Visit www.gskinner.com/blog for documentation, updates and more free code.*** Copyright (c) 2009 Grant Skinner* * Permission is hereby granted, free of charge, to any person* obtaining a copy of this software and associated documentation* files (the "Software"), to deal in the Software without* restriction, including without limitation the rights to use,* copy, modify, merge, publish, distribute, sublicense, and/or sell* copies of the Software, and to permit persons to whom the* Software is furnished to do so, subject to the following* conditions:* * The above copyright notice and this permission notice shall be* included in all copies or substantial portions of the Software.* * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,* EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES* OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND* NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT* HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,* WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING* FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR* OTHER DEALINGS IN THE SOFTWARE.**/package com.gskinner.motion {		import com.gskinner.motion.GTween;	import flash.utils.Dictionary;		/**	* <b>GTweenTimeline ©2008 Grant Skinner, gskinner.com. Visit www.gskinner.com/libraries/gtween/ for documentation, updates and more free code. Licensed under the MIT license - see the source file header for more information.</b>	* <hr>	* GTweenTimeline is a powerful sequencing engine for GTween. It allows you to build a virtual timeline	* with tweens, actions (callbacks), and labels. It supports all of the features of GTween, so you can repeat,	* reverse, and pause the timeline. You can even embed timelines within each other. GTweenTimeline adds about 1kb above GTween.	*/	public class GTweenTimeline extends GTween {	// static properties:		/**		* Sets a property value on a specified target object. This is provided to make it easy to set properties		* in a GTweenTimeline using <code>addCallback</code>. For example, to set the <code>visible</code> property to true on a movieclip "foo"		* at 3 seconds into the timeline, you could use the following code:<br/>		* <code>myTimeline.addCallback(3,GTweenTimeline.setPropertyValue,[foo,"visible",true]);</code>		* @param target The object to set the property value on.		* @param propertyName The name of the property to set.		* @param value The value to assign to the property.		**/		public static function setPropertyValue(target:Object,propertyName:String,value:*):void {			target[propertyName] = value;		}		// private properties:		/** @private **/		protected var callbacks:Array;		/** @private **/		protected var callbackPositions:Array;		/** @private **/		protected var labels:Object;		/** @private **/		protected var tweens:Array;		/** @private **/		protected var tweenStartPositions:Array;			// construction:		/**		* Constructs a new GTweenTimeline instance.		*		* @param target The object whose properties will be tweened. Defaults to null.		* @param duration The length of the tween in frames or seconds depending on the timingMode. Defaults to 10.		* @param properties An object containing destination property values. For example, to tween to x=100, y=100, you could pass <code>{x:100, y:100}</code> as the props object.		* @param tweenProperties An object containing properties to set on this tween. For example, you could pass <code>{ease:myEase}</code> to set the ease property of the new instance. This also provides a shortcut for setting up event listeners. See .setTweenProperties() for more information.		* @param tweens An array of alternating start positions and tween instances. For example, the following array would add 3 tweens starting at positions 2, 6, and 8: <code>[2, tween1, 6, tween2, 8, tween3]</code>		**/		public function GTweenTimeline(target:Object=null, duration:Number=10, properties:Object=null, tweenProperties:Object=null, tweens:Array=null):void {			super(target, duration, properties, tweenProperties);			this.tweens = [];			tweenStartPositions = [];			callbacks = [];			callbackPositions = [];			labels = {};			addTweens(tweens);			// unlike GTween, which waits for a setProperty to start playing, GTweenTimeline starts immediately:			if (autoPlay) { paused = false; }		}			// public getter / setters:		/**		* Returns the label at the current position, or the previous label irrespective of whether the tween is playing forwards or backwards. For example,		* if there are labels at 2, 4, and 7, and the current position is 6, the <code>currentLabel</code> will be the label at position 4.		**/		public function get currentLabel():String {			var minDelta:Number=duration+1;			var label:String;			for (var n:String in labels) {				var delta:Number = labels[n]-_tweenPosition;				if (delta >= 0 && delta < minDelta) {					label = n;				}			}			return label;		}			// public methods:		/**		* Adds a tween to the timeline, which will start playing at the specified start position.		* The tween will play synchronized with the timeline, with all of its behaviours intact (ex. <code>reversed</code>, <code>repeat</code>, <code>reflect</code>)		* except for <code>delay</code> (which is accomplished with the <code>startPosition</code> parameter instead).		*		* @param startPosition The starting position for this tween in frames or seconds (as per the timing mode of this tween).		* @param tween The GTween instance to add. Note that this can be any subclass of GTween, including another GTweenTimeline.		**/		public function addTween(startPosition:Number,tween:GTween):void {			if (tween == null || isNaN(startPosition)) { return; }			tween.autoPlay = false;			tween.paused = true;			var index:int = -1;			while (++index < tweens.length && tweenStartPositions[index] < startPosition) { }			tweens.splice(index,0,tween);			tweenStartPositions.splice(index,0,startPosition);			tween.position = _tweenPosition-startPosition;		}				/**		* Shortcut method for adding a number of tweens at once.		*		* @param tweens An array of alternating start positions and tween instances. For example, the following array would add 3 tweens starting at positions 2, 6, and 8: <code>[2, tween1, 6, tween2, 8, tween3]</code>		**/		public function addTweens(tweens:Array):void {			if (tweens == null) { return; }			for (var i:uint=0; i<tweens.length; i+=2) {				addTween(tweens[i],tweens[i+1] as GTween);			}		}				/**		* Removes the specified tween. Note that this will remove all instances of the tween		* if has been added multiple times to the timeline.		*		* @param tween The GTween instance to remove.		**/		public function removeTween(tween:GTween):void {			for (var i:int=tweens.length; i>=0; i--) {				if (tweens[i] == tween) {					tweens.splice(i,1);					tweenStartPositions.splice(i,1);				}			}		}				/**		* Adds a label at the specified position. You can use <code>gotoAndPlay</code> or <code>gotoAndStop</code> to jump to labels you add,		* or use <code>currentLabel</code> to check what the last label you passed was.		*		* @param tween The position to add the label at in frames or seconds (as per the timing mode of this tween).		* @param label The label to add.		**/		public function addLabel(position:Number,label:String):void {			labels[label] = position;		}				/**		* Removes the specified label.		*		* @param label The label to remove.		**/		public function removeLabel(label:String):void {			delete(labels[label]);		}				/**		* Adds a callback function at the specified position. When the timeline's playhead passes over or lands on the position while playing		* the callback will be called with the parameters specified. Callbacks will not be called when manually adjusting the position using the position		* property (see position for more information).		* <br/><br/>		* Note that this can be used in conjunction with the static <code>setPropertyValue</code> method to easily set properties on objects in the timeline.		*		* @param tween The position to add the callback at in frames or seconds (as per the timing mode of this tween).		* @param label The function to call.		* @param parameters Optional array of parameters to pass to the callback when it is called.		**/		public function addCallback(position:Number,callback:Function,parameters:Array=null):void {			var l:int = callbacks.length;			for (var i:int = l-1; i>=0; i--) {				if (position == callbackPositions[i]) {					callbacks[i] = {callback:callback,parameters:parameters};					return;				}				if (position > callbackPositions[i]) { break; }			}			callbacks.splice(i+1,0,{callback:callback,parameters:parameters});			callbackPositions.splice(i+1,0,position);		}						/**		* Removes the callback at the specified position.		*		* @param tween The position of the callback to remove in frames or seconds (as per the timing mode of this tween).		**/		public function removeCallback(position:Number):void {			var l:int = callbacks.length;			for (var i:int = 0; i<l; i++) {				if (position == callbackPositions[i]) {					callbacks.splice(i,1);					callbackPositions.splice(i,1);					return;				}			}		}				/**		* Jumps the timeline to the specified label or numeric position and plays it.		*		* @param labelOrPosition The label name or numeric position in frames or seconds (as per the timing mode of this tween) to jump to.		**/		public function gotoAndPlay(labelOrPosition:*):void {			goto(labelOrPosition);			paused = false;		}				/**		* Jumps the timeline to the specified label or numeric position and pauses it.		*		* @param labelOrPosition The label name or numeric position in frames or seconds (as per the timing mode of this tween) to jump to.		**/		public function gotoAndStop(labelOrPosition:*):void {			goto(labelOrPosition);			paused = true;		}				/**		* Jumps the timeline to the specified label or numeric position without affecting its paused state.		*		* @param labelOrPosition The label name or numeric position in frames or seconds (as per the timing mode of this tween) to jump to.		**/		public function goto(labelOrPosition:*):void {			if (!isNaN(labelOrPosition)) {				position = labelOrPosition;			} else {				var pos:Number = labels[String(labelOrPosition)];				if (!isNaN(pos)) { position = pos; }			}		}				/**		* Calculates the duration of the timeline based on the tweens and callbacks that have been added to it.		**/		public function calculateDuration():void {			var d:Number = 0;			if (callbacks.length > 0) {				d = callbackPositions[callbacks.length-1];			}			for (var i:int=0; i<tweens.length; i++) {				if (tweens[i].duration+tweenStartPositions[i] > d) {					d = tweens[i].duration+tweenStartPositions[i];				}			}			duration = d;		}						override public function setPosition(value:Number,suppressEvents:Boolean=true):void {			super.setPosition(value,suppressEvents);			// update tweens:			var repeatIndex:Number = _position/duration>>0;			var rev:Boolean = (reflect && repeatIndex%2>=1) != _reversed;			var i:int;			var l:int = tweens.length;			if (rev) {				for (i=0; i<l; i++) {					tweens[i].setPosition(_tweenPosition-tweenStartPositions[i],false);				}			} else {				for (i=l-1; i>=0; i--) {					tweens[i].setPosition(_tweenPosition-tweenStartPositions[i],false);				}			}						if (!suppressEvents) { checkCallbacks(); }		}			// protected methods:		// checks for callbacks between the previous and current position (inclusive of current, exclusive of previous).		/** @private **/		protected function checkCallbacks():void {			if (callbacks.length == 0) { return; }			var repeatIndex:Number = _position/duration>>0;			var previousRepeatIndex:Number = _previousPosition/duration>>0;			var matches:Array;						if (repeatIndex == previousRepeatIndex) {				checkCallbackRange(_previousTweenPosition, _tweenPosition);			} else {				// GDS: this doesn't currently support multiple repeats in one tick (ie. more than a single repeat).				var rev:Boolean = (reflect && previousRepeatIndex%2>=1) != _reversed;				checkCallbackRange(_previousTweenPosition, rev ? 0 : duration);				rev = (reflect && repeatIndex%2>=1) != _reversed;				checkCallbackRange(rev ? duration : 0, _tweenPosition, !reflect);			}		}				// checks for callbacks between a contiguous start and end position (ie. not broken by repeats).		/** @private **/		protected function checkCallbackRange(startPos:Number,endPos:Number,includeStart:Boolean=false):void {			var sPos:Number = startPos;			var ePos:Number = endPos;			var i:int = -1;			var j:int = callbacks.length;			var k:int = 1;			if (startPos > endPos) {				// running backwards, flip everything:				sPos = endPos;				ePos = startPos;				i = j;				j = k = -1;			}			while ((i+=k) != j) {				var pos:Number = callbackPositions[i];				if ( (pos > sPos && pos < ePos) || (pos == endPos) || (includeStart && pos == startPos) ) {					callbacks[i].callback.apply(this,callbacks[i].parameters);				}			}		}	}}