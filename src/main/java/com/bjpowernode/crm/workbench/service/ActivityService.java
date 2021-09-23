package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.vo.PaginationVo;
import com.bjpowernode.crm.workbench.domain.Activity;
import com.bjpowernode.crm.workbench.domain.ActivityRemark;

import java.util.List;
import java.util.Map;

public interface ActivityService {
    Boolean save(Activity activity);

    PaginationVo<Activity> pageList(Map<String, Object> map);

    boolean delete(String[] ids);

    Activity getActivity(String id);

    boolean update(Activity activity);

    Activity detail(String id);

    List<ActivityRemark> getRemarkList(String id);

    boolean deleteRemark(String id);

    Map<String, Object> saveRemark(ActivityRemark activityRemark);

    Map<String, Object> updateRemark(ActivityRemark activityRemark);

    List<Activity> showActivityList(String id);

    List<Activity> searchActivityList(String clueId, String name);

    List<Activity> searchActivityListConvert(String name);
}
