package com.quantumdataengines.app.listScanning.castExceptions;

public class SourceNotFoundError extends Exception
{
    public SourceNotFoundError(String a_strMessage, Exception a_exception)
    {
    super(a_strMessage);
    m_exception = a_exception;
    }

    public SourceNotFoundError(String a_strMessage)
    {
    this(a_strMessage, null);
    }

    public SourceNotFoundError(Exception a_exception)
    {
    this(null, a_exception);
    }

    public Exception getException()
    {
    return m_exception;
    }

    public Exception getRootCause()
    {
    if(m_exception instanceof SourceNotFoundError)
        return ((SourceNotFoundError)m_exception).getRootCause();
    else
        return ((Exception) (m_exception != null ? m_exception : this));
    }

    public String toString()
    {
    if(m_exception instanceof SourceNotFoundError)
        return ((SourceNotFoundError)m_exception).toString();
    else
        return m_exception != null ? m_exception.toString() : super.toString();
    }

    private Exception m_exception;
}