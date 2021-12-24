package com.kcube.kanban;

import com.kcube.doc.Item;

public class KbItemBackup extends Item
{
	private static final long serialVersionUID = 4543176050580752435L;

	private String _uuid;

	public String getUuid()
	{
		return _uuid;
	}

	public void setUuid(String uuid)
	{
		_uuid = uuid;
	}

}
