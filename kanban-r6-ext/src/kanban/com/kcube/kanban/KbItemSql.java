package com.kcube.kanban;

import java.io.PrintWriter;
import java.sql.ResultSet;
import java.util.Date;

import com.kcube.lib.action.ActionContext;
import com.kcube.lib.jdbc.DbService;
import com.kcube.lib.sql.SqlSelect;
import com.kcube.lib.sql.SqlTable;
import com.kcube.lib.sql.SqlWriter;
import com.kcube.sys.module.ModuleParam;
import com.kcube.sys.usr.UserService;

/**
 * 칸반 기본 SQL
 */
public class KbItemSql
{
	private static final SqlTable KBITEM = new SqlTable("kb_item", "i");
	private static final SqlTable KBITEMCARD = new SqlTable("kb_item_card", "s");
	private static final SqlTable KBITEMBACKUP = new SqlTable("kb_item_backup", "u");
	private static SqlWriter _writer = (SqlWriter) new SqlWriter().putAll(KBITEM);

	private ModuleParam _mp;
	private Long _moduleId;
	private Long _spaceId;
	private Long _appId;
	private Long _classId;

	public KbItemSql()
	{

	}

	public KbItemSql(ModuleParam mp) throws Exception
	{
		_moduleId = mp.getModuleId();
		_spaceId = mp.getSpaceId();
		_appId = mp.getAppId();
		_classId = mp.getClassId();
	}

	public static class LoadOrCreateByItem extends KbItemAction
	{
		public void execute(ActionContext ctx) throws Exception
		{
			SqlSelect stmt = new SqlSelect();
			stmt.select("itemid");
			stmt.from("kb_item");
			stmt.where("userid = ? ", UserService.getUserId());
			stmt.where("isvisb = ? ", true);
			stmt.where("status = ? ", KbItem.REGISTERED_STATUS);
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
				DbService.save(server);
			}
			_factory.marshal(ctx.getWriter(), server);
		}
	}

	public void writeJson(PrintWriter writer, SqlSelect select) throws Exception
	{
		_writer.list(writer, select);
	}

	public SqlSelect getCategory() throws Exception
	{
		SqlSelect stmt = new SqlSelect();
		stmt.select("i.*");
		stmt.from(KBITEM);
		stmt.where("i.status = ?", KbItem.REGISTERED_STATUS);
		stmt.where("i.appid = ?", _appId);
		stmt.where("i.moduleid = ?", _moduleId);
		stmt.where("i.tenantid =?", UserService.getTenantId());
		stmt.where("i.userid =?", UserService.getUserId());
		return stmt;
	}

	public SqlSelect backUpCard(Long id, String uuid) throws Exception
	{
		SqlSelect stmt = new SqlSelect();
		stmt.select("s.*");
		stmt.from(KBITEMCARD);
		stmt.where("s.status = ?", KbItem.REGISTERED_STATUS);
		stmt.where("s.itemid = ?", id);
		stmt.where("s.row_point = ?", uuid);
		return stmt;
	}

	public SqlSelect restoreCard(Long id, String uuid) throws Exception
	{
		SqlSelect stmt = new SqlSelect();
		stmt.select("s.*");
		stmt.from(KBITEMCARD);
		stmt.where("s.status = ?", KbItemCard.BACKUP_STATUS);
		stmt.where("s.itemid = ?", id);
		stmt.where("s.row_point = ?", uuid);
		return stmt;
	}

	public SqlSelect getItemid()
	{
		SqlSelect stmt = new SqlSelect();
		stmt.select("i.itemid");
		stmt.from(KBITEM);
		stmt.where("i.appid = ?", _appId);
		stmt.where("i.moduleid = ?", _moduleId);
		stmt.where("i.userid = ?", UserService.getUserId());
		return stmt;
	}

	public SqlSelect getBackupCategory()
	{
		SqlSelect stmt = new SqlSelect();
		stmt.select("u.itemid");
		stmt.from(KBITEMBACKUP);
		stmt.where("u.userid =?", UserService.getUserId());
		return stmt;
	}

	public SqlSelect getBackupItemid(String uuid)
	{
		SqlSelect stmt = new SqlSelect();
		stmt.select("u.itemid");
		stmt.from(KBITEMBACKUP);
		stmt.where("u.userid =?", UserService.getUserId());
		stmt.where("u.uuid LIKE ?", uuid);
		return stmt;
	}
}
