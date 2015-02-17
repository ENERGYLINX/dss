package eu.europa.ec.markt.dss;

import java.io.File;
import java.io.FileInputStream;
import java.io.FileOutputStream;
import java.io.IOException;
import java.io.InputStream;

import org.apache.commons.io.IOUtils;
import org.apache.pdfbox.pdmodel.PDDocument;

import eu.europa.ec.markt.dss.exception.DSSException;
import eu.europa.ec.markt.dss.signature.pdf.PdfArray;

/**
 * This class proposes some utility methods to manipulate PDF files.
 *
 */
public final class DSSPDFUtils {

	private DSSPDFUtils() {
	}

	public static byte[] getBytes(final PdfArray crlArray, final int ii) throws DSSException {

		try {

			return crlArray.getBytes(ii);
		} catch (IOException e) {
			throw new DSSException(e);
		}
	}

	/**
	 * This method returns the temporary {@code File} with the provided contents.
	 *
	 * @param pdfData {@code InputStream} representing the contents of the returned {@code File}
	 * @return {@code File} with the given contents
	 * @throws DSSException in case of any {@code IOException}
	 */
	public static File getFileFromPdfData(final InputStream pdfData) throws DSSException {

		FileOutputStream fileOutputStream = null;
		try {

			final File file = File.createTempFile("sd-dss-", ".pdf");
			fileOutputStream = new FileOutputStream(file);
			IOUtils.copy(pdfData, fileOutputStream);
			return file;
		} catch (IOException e) {
			throw new DSSException("The process has no rights to write or to access 'java.io.tmpdir': " + System.getProperty("java.io.tmpdir"), e);
		} finally {
			IOUtils.closeQuietly(pdfData);
			IOUtils.closeQuietly(fileOutputStream);
		}
	}

	/**
	 *
	 *
	 * @param toSignFile
	 * @param signedFile
	 * @return
	 * @throws DSSException
	 */
	public static FileOutputStream getFileOutputStream(final File toSignFile, final File signedFile) throws DSSException {

		FileInputStream fileInputStream = null;
		try {

			final FileOutputStream fileOutputStream = new FileOutputStream(signedFile);
			fileInputStream = new FileInputStream(toSignFile);
			IOUtils.copy(fileInputStream, fileOutputStream);
			return fileOutputStream;
		} catch (IOException e) {
			IOUtils.closeQuietly(fileInputStream);
			throw new DSSException(e);
		}
	}

	public static void close(PDDocument doc) throws DSSException {

		if (doc != null) {

			try {
				doc.close();
			} catch (IOException e) {
				throw new DSSException(e);
			}
		}
	}
}