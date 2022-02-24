package com.quantumdataengines.app.listScanning.listSearch;

public class ScreeningResultVO
{
    public ScreeningResultVO()
    {
    	id = null;
    	record = null;
        listName = null;
        matchField = null;
        matchData = null;
        sourceField = null;
        sourceData = null;
        score = 0;
        sourceId = null;
        matchType = null;
        opt_key = null;
        mand_key = null;
        category = null;
        sub_category = null;
        nationality = null;
    }

    public String getRecord()
    {
        return record;
    }
    public void setRecord(String record)
    {
        this.record = record;
    }

    public int getScore()
    {
        return score;
    }
    public void setScore(int score)
    {
        this.score = score;
    }

    public String getId()
    {
        return id;
    }
    public void setId(String id)
    {
        this.id = id;
    }

    public String getListName()
    {
        return listName;
    }
    public void setListName(String listName)
    {
        this.listName = listName;
    }

    public String getMatchField()
    {
        return matchField;
    }
    public void setMatchField(String matchField)
    {
        this.matchField = matchField;
    }

    public String getSourceField()
    {
        return sourceField;
    }
    public void setSourceField(String SourceField)
    {
        sourceField = SourceField;
    }

    public String getMatchData()
    {
        return matchData;
    }
    public void setMatchData(String matchData)
    {
        this.matchData = matchData;
    }

    public void setSourceData(String sourceData)
    {
        this.sourceData = sourceData;
    }
    public String getSourceData()
    {
        return sourceData;
    }

    public void setSourceId(String sourceId)
    {
        this.sourceId = sourceId;
    }
    public String getSourceId()
    {
        return sourceId;
    }

    public void setMatchType(String matchType)
    {
        this.matchType = matchType;
    }
    public String getMatchType()
    {
        return matchType;
    }

    public String getCategory()
    {
        return category;
    }
    public void setCategory(String category)
    {
        this.category = category;
    }

    public String getMand_key()
    {
        return mand_key;
    }
    public void setMand_key(String mand_key)
    {
        this.mand_key = mand_key;
    }

    public String getNationality()
    {
        return nationality;
    }
    public void setNationality(String nationality)
    {
        this.nationality = nationality;
    }

    public String getOpt_key()
    {
        return opt_key;
    }
    public void setOpt_key(String opt_key)
    {
        this.opt_key = opt_key;
    }

    public String getSub_category()
    {
        return sub_category;
    }
    public void setSub_category(String sub_category)
    {
        this.sub_category = sub_category;
    }

    public String getDOB()
    {
        return DOB;
    }
    public void setDOB(String dob)
    {
        DOB = dob;
    }

    public String getPlaceOfBirth()
    {
        return placeOfBirth;
    }
    public void setPlaceOfBirth(String placeOfBirth)
    {
        this.placeOfBirth = placeOfBirth;
    }

    public String getPassportID()
    {
        return passportID;
    }
    public void setPassportID(String passportID)
    {
        this.passportID = passportID;
    }

    public String getLocalID()
    {
        return localID;
    }
    public void setLocalID(String localID)
    {
        this.localID = localID;
    }

    public String getAddress()
    {
        return address;
    }
    public void setAddress(String address)
    {
        this.address = address;
    }

    private String id;
    private String listName;
    private String record;
    private String matchField;
    private String matchData;
    private String sourceField;
    private String sourceData;
    private String sourceId;
    private int score;
    private String matchType;
    private String opt_key;
    private String mand_key;
    private String category;
    private String sub_category;
    private String nationality;
    private String passportID;
    private String localID;
    private String placeOfBirth;
    private String DOB;
    private String address;
}