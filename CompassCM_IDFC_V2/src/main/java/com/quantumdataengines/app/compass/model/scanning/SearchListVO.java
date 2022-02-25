package com.quantumdataengines.app.compass.model.scanning;

public class SearchListVO
{

    public SearchListVO()
    {
    }

    public void setSearchLevel(String searchLevel)
    {
        this.searchLevel = searchLevel;
    }

    public String getSearchLevel()
    {
        return searchLevel;
    }

    public void setListName(String listName)
    {
        this.listName = listName;
    }

    public String getListName()
    {
        return listName;
    }

    public void setListCode(String listCode)
    {
        this.listCode = listCode;
    }

    public String getListCode()
    {
        return listCode;
    }

    private String listName;
    private String listCode;
    private String searchLevel;
}