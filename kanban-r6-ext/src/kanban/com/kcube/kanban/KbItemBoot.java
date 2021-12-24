package com.kcube.kanban;

import com.kcube.lib.action.ActionService;
import com.kcube.sys.AppBoot;

public class KbItemBoot implements AppBoot
{
	public void init() throws Exception
	{
		ActionService.addAction(new KbItemOwner());
		ActionService.addAction(new KbItemCardUser());
		ActionService.addAction(new KbItemCardOpinion());
		ActionService.addAction(new KbItemJob());
	}

	public void destroy()
	{

	}
}
