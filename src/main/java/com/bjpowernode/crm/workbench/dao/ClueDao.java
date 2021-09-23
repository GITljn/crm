package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.Clue;

import java.util.List;
import java.util.Map;

public interface ClueDao {
    int save(Clue clue);

    int total(Map<String, Object> map);

    List<Clue> pageList(Map<String, Object> map);

    Clue getClueById(String id);

    int update(Clue clue);

    int delete(String[] ids);

    Map<String, Object> getClueAndOwnerById(String id);
}
