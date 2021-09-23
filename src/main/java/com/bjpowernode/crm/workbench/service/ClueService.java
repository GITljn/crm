package com.bjpowernode.crm.workbench.service;

import com.bjpowernode.crm.workbench.domain.Clue;
import com.bjpowernode.crm.workbench.domain.ClueRemark;

import java.util.List;
import java.util.Map;

public interface ClueService {
    boolean save(Clue clue);

    Map<String, Object> pageList(Map<String, Object> map);

    Map<String, Object> getUserListAndClue(String id);

    boolean update(Clue clue);

    boolean delete(String[] ids);

    Map<String, Object> getClueAndOwnerById(String id);

    List<ClueRemark> showRemarkList(String clueId);

    Map<String, Object> saveRemark(ClueRemark clueRemark);

    boolean deleteRemark(String id);

    Map<String, Object> updateRemark(ClueRemark clueRemark);

    boolean unBind(String id);

    boolean bind(String clueId, String[] ids);
}
