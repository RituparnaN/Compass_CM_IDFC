package com.quantumdataengines.app.listScanning.castExceptions;

public class FileNotFoundError extends Exception
{

    public FileNotFoundError(String a_strMessage, Exception a_exception)
    {
    super(a_strMessage);
    m_exception = a_exception;
    }

    public FileNotFoundError(String a_strMessage)
    {
    this(a_strMessage, null);
    }

    public FileNotFoundError(Exception a_exception)
    {
    this(null, a_exception);
    }

    public Exception getException()
    {
    return m_exception;
    }

    public Exception getRootCause()
    {
    if(m_exception instanceof FileNotFoundError)
        return ((FileNotFoundError)m_exception).getRootCause();
    else
        return ((Exception) (m_exception != null ? m_exception : this));
    }

    public String toString()
    {
    if(m_exception instanceof FileNotFoundError)
        return ((FileNotFoundError)m_exception).toString();
    else
        return m_exception != null ? m_exception.toString() : super.toString();
    }

    private Exception m_exception;
}