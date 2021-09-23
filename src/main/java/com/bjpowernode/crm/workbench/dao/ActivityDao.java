package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityDao {
    int save(Activity activity);

    List<Activity> pageList(Map<String, Object> map);

    int total(Map<String, Object> map);

    int delete(String[] ids);

    Activity getActivity(String id);

    int update(Activity activity);

    Activity detail(String id);

    List<Activity> showActivityList(String id);

    List<Activity> searchActivityList(Map<String, Object> map);

    List<Activity> searchActivityListConvert(String name);
}
