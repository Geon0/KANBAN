package com.kcube.kanban;

import java.sql.ResultSet;

import com.kcube.lib.action.ActionContext;
import com.kcube.lib.sql.SqlDialect;
import com.kcube.lib.sql.SqlSelect;
import com.kcube.sys.module.ModuleParam;
import com.kcube.sys.usr.UserPermission;

public class KbItemJob
{
	/**
	 * 지정한 종료시간에 도달하면 판매중 게시물을 경매종료상태로 변경한다. 최신입찰상태의 정보를 SET해준다.
	 */
	public static class EndTime extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			UserPermission.isAdmin();
			SqlSelect master = new SqlSelect();
			master.select("*");
			master.from("kb_item_card");
			master.where("end_date <= " + SqlDialect.sysdate());
			master.where("status = ?", KbItemCard.REGISTERED_STATUS);
			ResultSet rs = master.query();
			Long id = null;
			Long userid = null;
			Long itemid = null;
			while (rs.next())
			{
				id = rs.getLong("cardid");
				userid = rs.getLong("rgst_userid");
				KbItemCard card = (KbItemCard) _cardStorage.load(id);

				SqlSelect sub = new SqlSelect();
				sub.select("itemid");
				sub.from("kb_item");
				sub.where("userid = ?", userid);
				ResultSet rss = sub.query();
				while (rss.next())
				{
					itemid = rs.getLong("itemid");
				}

				KbItem server = (KbItem) _storage.loadWithLock(itemid);
				ModuleParam mp = new ModuleParam(
					server.getClassId(), server.getModuleId(), server.getSpaceId(), null, server.getAppId());
				KbItemCardHistory.endTime(mp, card);

			}
		}
	}
}
