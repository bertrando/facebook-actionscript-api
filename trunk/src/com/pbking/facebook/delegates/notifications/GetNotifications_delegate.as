package com.pbking.facebook.delegates.notifications
{
	import com.pbking.facebook.data.notifications.Notification;
	import com.pbking.facebook.data.notifications.NotificationList;
	import com.pbking.facebook.delegates.FacebookDelegate;
	import com.pbking.util.logging.PBLogger;
	
	public class GetNotifications_delegate extends FacebookDelegate
	{
		
		public var notifications:Object = new Object();
		public var notificationLists:Object = new Object();
		
		public function GetNotifications_delegate()
		{
			PBLogger.getLogger("pbking.facebook").debug("getting notifications");
			
			fbCall.post("facebook.notifications.get");
		}
		
		override protected function handleResult(result:Object):void
		{
			default xml namespace = fBook.FACEBOOK_NAMESPACE;
			//TODO: write this for JSON handling
		}
		
	}
}