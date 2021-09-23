package com.bjpowernode.crm.workbench.dao;

import com.bjpowernode.crm.workbench.domain.ClueActivityRelation;

import java.util.Map;

public interface ClueActivityRelationDao {

    int unBind(String id);

    int bind(Map<String, Object> map);
}
