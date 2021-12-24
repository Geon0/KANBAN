package com.kcube.kanban;

import java.util.Date;

import com.kcube.doc.file.Attachment;
import com.kcube.sys.usr.User;

public abstract class KbItemCardAttachment extends Attachment
{
	private static final long serialVersionUID = -2102483563065038403L;

	private Long _gid;
	private User _rgstUser;
	private Long _vrsnNum;
	private boolean _lastVersion;
	private Date _instDate;

	public Long getGid()
	{
		if (_gid == null)
			setGid(getId());
		return _gid;
	}

	public void setGid(Long gid)
	{
		_gid = gid;
	}

	public User getRgstUser()
	{
		return _rgstUser;
	}

	public void setRgstUser(User rgstUser)
	{
		_rgstUser = rgstUser;
	}

	public Long getVrsnNum()
	{
		if (_vrsnNum == null)
			_vrsnNum = (long) 1;
		return _vrsnNum;
	}

	public void setVrsnNum(Long vrsnNum)
	{
		_vrsnNum = vrsnNum;
	}

	public boolean isLastVersion()
	{
		return _lastVersion;
	}

	public void setLastVersion(boolean lastVersion)
	{
		_lastVersion = lastVersion;
	}

	public Date getInstDate()
	{
		return _instDate;
	}

	public void setInstDate(Date instDate)
	{
		_instDate = instDate;
	}
}
