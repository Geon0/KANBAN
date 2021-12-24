package com.kcube.kanban;

import com.kcube.sys.alimi.AlimiManager;
import com.kcube.sys.emp.Employee;
import com.kcube.sys.emp.EmployeeService;
import com.kcube.sys.module.ModuleParam;
import com.kcube.sys.usr.User;

public class KbItemCardHistory
{

	public static final Integer ENDTIME = new Integer(5000);
	public static final String ALIMI_KANBAN = "KANBAN";
	public static final String ENDTIME_ALIMI = "com.kcube.kanban.KbItem.endTime";

	static void endTime(ModuleParam mParam, KbItemCard item) throws Exception
	{
		if (item.getEndDate() != null)
		{
			AlimiManager.log(
				mParam,
				ENDTIME,
				item.getRgstUser().getUserId(),
				item.getTitle(),
				getSystemUser(),
				ENDTIME_ALIMI,
				null,
				ALIMI_KANBAN,
				item,
				item.getId());
		}
	}

	/**
	 * 시스템의 정보를 User 객체로 리턴해준다.
	 */
	static User getSystemUser() throws Exception
	{
		Employee emp = EmployeeService.getEmployee(0L);
		return new User(emp.getUser());
	}

}
