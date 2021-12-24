package com.kcube.kanban;

import java.sql.ResultSet;
import java.util.Date;

import org.json.simple.JSONArray;
import org.json.simple.JSONObject;
import org.json.simple.parser.JSONParser;

import com.kcube.doc.ItemPermission;
import com.kcube.lib.action.ActionContext;
import com.kcube.lib.jdbc.DbService;
import com.kcube.lib.sql.SqlDialect;
import com.kcube.lib.sql.SqlSelect;
import com.kcube.lib.sql.SqlUpdate;
import com.kcube.sys.module.ModuleParam;
import com.kcube.sys.usr.UserService;

public class KbItemOwner
{
	/**
	 * 개인 칸반의 칸반정보를 생성 또는 로드한다.
	 */
	public static class LoadOrCreateByItem extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			ModuleParam mp = ctx.getModuleParam();
			SqlSelect stmt = new SqlSelect();
			stmt.select("itemid");
			stmt.from("kb_item");
			stmt.where("userid = ? ", UserService.getUserId());
			stmt.where("isvisb = ? ", true);
			stmt.where("status = ? ", KbItem.REGISTERED_STATUS);
			stmt.where("appid = ?", mp.getAppId());
			stmt.where("moduleid = ?", mp.getModuleId());
			stmt.where("classid = ?", mp.getClassId());
			stmt.where("spid = ?", mp.getSpaceId());
			stmt.where("tenantid = ?", UserService.getTenantId());
			ResultSet rs = stmt.query();
			KbItem server;
			if (rs.next())
			{
				server = (KbItem) _storage.load(rs.getLong("itemid"));
			}
			else
			{
				server = new KbItem();
				server.setRgstUser(UserService.getUser());
				server.setStatus(KbItem.REGISTERED_STATUS);
				server.setVisible(true);
				server.setInstDate(new Date());
				server.setLastUpdt(new Date());
				server.setAppId(mp.getAppId());
				server.setModuleId(mp.getModuleId());
				server.setClassId(mp.getClassId());
				server.setSpaceId(mp.getSpaceId());
				server.setTenantId(UserService.getTenantId());
				DbService.save(server);
			}
			_factory.marshal(ctx.getWriter(), server);
		}
	}

	/**
	 * 나의 칸반 정보를 돌려준다.
	 */
	public static class ReadByOwner extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItem server = (KbItem) _storage.load(ctx.getLong("id"));
			ItemPermission.checkOwner(server);
			_factory.marshal(ctx.getWriter(), server);
		}
	}

	/**
	 * 나의 칸반 카테고리 정보를 돌려준다. 백업 정보 가져오기 사용
	 * @author geon-0
	 */
	public static class GetCategoryInfo extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			ModuleParam mp = ctx.getModuleParam();
			KbItemSql sql = new KbItemSql(mp);
			SqlSelect stmt = sql.getCategory();
			sql.writeJson(ctx.getWriter(), stmt);
		}
	}

	/**
	 * 칸반 카테고리 정보를 돌려준다.
	 */
	public static class ReadCategory extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			KbItem server = (KbItem) _storage.load(ctx.getLong("id"));
			_factory.marshal(ctx.getWriter(), server);
		}
	}

	/**
	 * 칸반 백업을 실행한다.
	 * @author geon-0
	 */
	public static class DoBackupCard extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			ModuleParam mp = ctx.getModuleParam();
			Long id = null;

			JSONParser parser = new JSONParser();
			JSONObject jsonObject = (JSONObject) parser.parse(ctx.getParameter("item"));
			JSONArray ctSelect = (JSONArray) jsonObject.get("item");

			for (int i = 0; i < ctSelect.size(); i++)
			{
				KbItemBackup backup = (KbItemBackup) _backupstorage.create();
				backup.setUuid(ctSelect.get(i).toString());
				backup.setRgstUser(UserService.getUser());
				backup.setRgstDate(new Date());
			}

			KbItemSql sql = new KbItemSql(mp);
			SqlSelect master = sql.getItemid();
			ResultSet result = master.query();

			if (result.next())
			{
				id = result.getLong("itemid");
				KbItem server = (KbItem) _storage.loadWithLock(id);
				Object obj = parser.parse(server.getContent());
				JSONArray ctOrgin = (JSONArray) obj;
				ctOrgin.removeAll(ctSelect); // jsonarray 중복 제거
				server.setContent(ctOrgin.toJSONString());
			}

			for (int i = 0; i < ctSelect.size(); i++)
			{
				JSONObject obj = (JSONObject) ctSelect.get(i);
				SqlSelect stmt = sql.backUpCard(id, obj.get("uuid").toString());
				ResultSet rs = stmt.query();

				while (rs.next())
				{
					Long cardid = rs.getLong("cardid");
					KbItemCard card = (KbItemCard) _cardStorage.loadWithLock(cardid);
					ItemPermission.checkOwner(card);
					card.setStatus(KbItemCard.BACKUP_STATUS);
					card.setVisible(false);
					card.setLastUpdt(new Date());
				}
			}
		}
	}

	/**
	 * 카드 목록을 호출한다.
	 */
	public static class LoadLayoutByOwner extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			KbItem item = (KbItem) _storage.load(id);
			ItemPermission.checkOwner(item);
			String layout = item.getContent();
			if (layout == null)
				layout = "[]";
			ctx.getWriter().write(layout);
		}
	}

	/**
	 * 백업된 카드를 호출한다
	 * @author geon-0
	 */

	public static class LoadBackupLayoutByOwner extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			ModuleParam mp = ctx.getModuleParam();
			KbItemSql sql = new KbItemSql(mp);
			SqlSelect master = sql.getBackupCategory();
			ResultSet rs = master.query();

			Long id = null;
			String layout = "";
			String backupLayout = "";

			while (rs.next())
			{
				id = rs.getLong("itemid");
				KbItemBackup item = (KbItemBackup) _backupstorage.load(id);
				ItemPermission.checkOwner(item);

				if (item.getUuid() == null)
				{
					backupLayout = "";
				}

				else
				{
					layout += item.getUuid() + ",";
					backupLayout = layout.replaceAll(",$", "");
				}
			}
			ctx.getWriter().write("[" + backupLayout + "]");
		}
	}

	/**
	 * 카드 목록을 호출한다.
	 */
	public static class SaveLayoutByOwner extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			String ctg = ctx.getParameter("ctg");
			KbItem item = (KbItem) _storage.loadWithLock(id);
			ItemPermission.checkOwner(item);
			item.setContent(ctg);
		}
	}

	/**
	 * 카테고리를 수정 시 해당 카드들의 카테고리 정보 업데이트 작업만 수행한다.
	 * @author geon-0
	 */
	public static class CategoryUpdateByOwner extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			Long id = ctx.getLong("id");
			String rowPoint = ctx.getParameter("uuid");
			String title = ctx.getParameter("title");

			KbItem item = (KbItem) _storage.loadWithLock(id);
			ItemPermission.checkOwner(item);

			SqlUpdate updt = new SqlUpdate("kb_item_card");
			updt.setString("row_title", title);
			updt.where(SqlDialect.upper("row_point") + " like ?", rowPoint.toUpperCase());
			updt.execute();
		}
	}
}
