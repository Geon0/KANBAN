package com.kcube.kanban;

import java.util.Date;
import java.util.Set;
import java.util.TreeSet;

import com.kcube.doc.Item;
import com.kcube.sys.usr.UserService;

public class KbItemCard extends Item
{
	private static final long serialVersionUID = 2038922504615945651L;

	/**
	 * 백업 상태
	 */
	public static final int BACKUP_STATUS = 9400;

	/**
	 * 칸반 카테고리 삭제용 예약 코드
	 */
	public static final String del_row_point = "DELETE";
	public static final String del_row_title = "DELETE";

	private Long _itemId;
	private String _color;
	private Date _startDate;
	private Date _endDate;
	private int _fileCnt;
	private String _rowPoint;
	private String _rowTitle;
	private String _columnPoint;
	private String _columnTitle;
	private Long _sort;
	private boolean _sec;
	private Set<? extends KbItemCard.CardAttachment> _cardAttachments;

	public Long getItemId()
	{
		return _itemId;
	}

	public void setItemId(Long itemId)
	{
		_itemId = itemId;
	}

	public String getColor()
	{
		return _color;
	}

	public void setColor(String color)
	{
		_color = color;
	}

	public Date getStartDate()
	{
		return _startDate;
	}

	public void setStartDate(Date startDate)
	{
		_startDate = startDate;
	}

	public Date getEndDate()
	{
		return _endDate;
	}

	public void setEndDate(Date endDate)
	{
		_endDate = endDate;
	}

	public int getFileCnt()
	{
		return _fileCnt;
	}

	public void setFileCnt(int fileCnt)
	{
		_fileCnt = fileCnt;
	}

	public String getRowPoint()
	{
		return _rowPoint;
	}

	public void setRowPoint(String rowPoint)
	{
		_rowPoint = rowPoint;
	}

	public String getRowTitle()
	{
		return _rowTitle;
	}

	public void setRowTitle(String rowTitle)
	{
		_rowTitle = rowTitle;
	}

	public String getColumnPoint()
	{
		return _columnPoint;
	}

	public void setColumnPoint(String columnPoint)
	{
		_columnPoint = columnPoint;
	}

	public String getColumnTitle()
	{
		return _columnTitle;
	}

	public void setColumnTitle(String columnTitle)
	{
		_columnTitle = columnTitle;
	}

	public Long getSort()
	{
		return _sort;
	}

	public void setSort(Long sort)
	{
		_sort = sort;
	}

	public boolean isSec()
	{
		return _sec;
	}

	public void setSec(boolean sec)
	{
		_sec = sec;
	}

	public Set<? extends CardAttachment> getCardAttachments()
	{
		return _cardAttachments;
	}

	public void setCardAttachments(Set<? extends CardAttachment> cardAttachments)
	{
		_cardAttachments = cardAttachments;
	}

	public Set<? extends CardAttachment> getLastCardAttachments()
	{
		Set<CardAttachment> newAttachments = new TreeSet<CardAttachment>();
		if (null != _cardAttachments)
		{
			for (CardAttachment att : _cardAttachments)
			{
				if (att.isLastVersion())
				{
					newAttachments.add(att);
				}
			}
		}
		return newAttachments;
	}

	public static class CardAttachment extends KbItemCardAttachment
	{
		private static final long serialVersionUID = 8571575622461499031L;
	}

	/**
	 * 지식의 의견을 나타내는 클래스이다.
	 */
	public static class Opinion extends com.kcube.doc.opn.Opinion
	{
		private static final long serialVersionUID = -4723336928662794702L;
		private Long _rgstUserId;

		/**
		 * 등록자의 UserId
		 */
		public Long getRgstUserId()
		{
			return _rgstUserId;
		}

		public void setRgstUserId(Long rgstUserId)
		{
			_rgstUserId = rgstUserId;
		}

		/**
		 * 현재 사용자가 의견의 작성자 인지의 여부를 돌려준다.
		 */
		public boolean isCurrentOwner()
		{
			Long userId = UserService.getUserId();
			if (userId == null)
			{
				return false;
			}
			return (userId.equals(getRgstUserId()));
		}

		public void setCurrentOwner(boolean currentOwner)
		{
		}

	}
}
