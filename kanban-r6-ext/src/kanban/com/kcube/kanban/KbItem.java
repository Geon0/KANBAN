package com.kcube.kanban;

import java.util.Date;

import com.kcube.doc.Item;

public class KbItem extends Item
{
	private static final long serialVersionUID = -4363876064759935182L;

	private Date _instDate;
	private Long _itemId;

	/**
	 * 등록일시를 돌려준다.
	 * @return
	 */
	public Date getInstDate()
	{
		return _instDate;
	}

	public void setInstDate(Date instDate)
	{
		_instDate = instDate;
	}

	public Long getItemId()
	{
		return _itemId;
	}

	public void setItemId(Long itemId)
	{
		_itemId = itemId;
	}

}
