package com.quantumdataengines.app.compass.controller.reports;

import org.apache.poi.xwpf.usermodel.XWPFDocument;
import org.springframework.core.io.Resource;
import org.springframework.core.io.support.LocalizedResourceHelper;
import org.springframework.web.servlet.support.RequestContextUtils;
import org.springframework.web.servlet.view.AbstractView;

import javax.servlet.ServletOutputStream;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.util.Locale;
import java.util.Map;

public abstract class AbstractWordView extends AbstractView {
	/** The content type for an Word(.docX) response */
	private static final String CONTENT_TYPE = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";

	/** The extension to look for existing templates */
	private static final String EXTENSION = ".docx";


	private String url;


	/**
	 * Default Constructor.
	 * Sets the content type of the view to "application/vnd.openxmlformats-officedocument.wordprocessingml.document".
	 */
	public AbstractWordView() {
		setContentType(CONTENT_TYPE);
	}

	/**
	 * Set the URL of the Word workbook source, without localization part nor extension.
	 */
	public void setUrl(String url) {
		this.url = url;
	}


	@Override
	protected boolean generatesDownloadContent() {
		return true;
	}

	/**
	 * Renders the Word view, given the specified model.
	 */
	@Override
	protected final void renderMergedOutputModel(
			Map<String, Object> model, HttpServletRequest request, HttpServletResponse response) throws Exception {

		XWPFDocument document;
		if (this.url != null) {
			document = getTemplateSource(this.url, request);
		}
		else {
			document = new XWPFDocument();
			logger.debug("Created Word Document from scratch");
		}

		buildWordDocument(model, document, request, response);

		// Set the content type.
		response.setContentType(getContentType());

		// Should we set the content length here?
		// response.setContentLength(workbook.getBytes().length);

		// Flush byte array to servlet output stream.
		ServletOutputStream out = response.getOutputStream();
		document.write(out);
		out.flush();
	}

	/**
	 * Creates the workbook from an existing XLS document.
	 * @param url the URL of the Word template without localization part nor extension
	 * @param request current HTTP request
	 * @return the HSSFWorkbook
	 * @throws Exception in case of failure
	 */
	protected XWPFDocument getTemplateSource(String url, HttpServletRequest request) throws Exception {
		LocalizedResourceHelper helper = new LocalizedResourceHelper(getApplicationContext());
		Locale userLocale = RequestContextUtils.getLocale(request);
		Resource inputFile = helper.findLocalizedResource(url, EXTENSION, userLocale);

		// Create the Word document from the source.
		if (logger.isDebugEnabled()) {
			logger.debug("Loading Word Document from " + inputFile);
		}
		return new XWPFDocument(inputFile.getInputStream());
	}

	/**
	 * Subclasses must implement this method to create an Word XWPFDocument document,
	 * given the model.
	 * @param model the model Map
	 * @param document the Word workbook to complete
	 * @param request in case we need locale etc. Shouldn't look at attributes.
	 * @param response in case we need to set cookies. Shouldn't write to it.
	 */
	protected abstract void buildWordDocument(Map<String, Object> model, XWPFDocument document, HttpServletRequest request, HttpServletResponse response)
			throws Exception;
}