package com.quantumdataengines.app.listScanning.listIndexing;

import com.quantumdataengines.app.listScanning.castExceptions.*;
import com.quantumdataengines.app.listScanning.dataInfoReaders.main.ListReader;

public interface GenerateIndexes
{
    public abstract void createListIndexing(ListReader objListReader, String strIndexPath) throws CreateIndexError, IOAccessError, SourceNotFoundError, IllegalArgumentException;
    public abstract void createIndexingWithFolder(ListReader objListReader, String strIndexPath, String strIndexPath1, String strIndexPath2) throws CreateIndexError, IOAccessError, SourceNotFoundError, IllegalArgumentException;
    public abstract int countOfIndexedRecords();
    public abstract boolean hasIndexingDone();
}