package execireport;

import java.awt.Toolkit;
import java.io.BufferedReader;
import java.io.OutputStream;
import java.io.FileOutputStream;
import java.io.ByteArrayOutputStream;

import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.HashMap;
import java.util.Properties;
import java.io.File;
import java.io.FileInputStream;
import java.io.FileNotFoundException;
import java.io.FileReader;
import java.io.IOException;
import net.sf.jasperreports.engine.JRException;
import net.sf.jasperreports.engine.JasperFillManager;
import net.sf.jasperreports.engine.JasperPrint;
import net.sf.jasperreports.view.JasperViewer;
import net.sf.jasperreports.engine.JasperExportManager;

import net.sf.jasperreports.engine.export.JRXlsExporter;
import net.sf.jasperreports.engine.export.JRXlsExporterParameter;

import java.sql.Connection;
import java.sql.ResultSet;
import java.sql.Statement;
import net.sf.jasperreports.engine.JRResultSetDataSource;

public class Main {

    public static void main(String[] args) throws JRException, ClassNotFoundException, IOException, Exception
    { new Main().ExibeRelatorio( args[0].toString(), Integer.parseInt( args[1].toString() ), args[2].toString(), args[3].toString(), Integer.parseInt( args[4].toString() ) ); }

     private void ExibeRelatorio( String sQuery, Integer iModExbRel, String sNomeRelJasper, String sParamFileCfg, Integer iExecShell ) throws Exception
    {
        try {
        File file           = new File( sParamFileCfg );
        Properties props    = new Properties();
        FileInputStream fis = null;

        try
        { fis = new FileInputStream(file);
        props.load(fis);
        fis.close(); }
        catch (IOException ex)
        { System.out.println( ex.getMessage() ); }

        try
        { String sdriver          = props.getProperty("DRIVER");
          String surl             = props.getProperty("URL");
          String suser            = props.getProperty("USER");
          String spassword        = props.getProperty("PASSWORD");
          String stituloview      = props.getProperty("TITULOVIEW");
          String spathiconeview   = props.getProperty("PATHICONEVIEW");
          String spathrelajasper  = props.getProperty("PATHRELJASPER");

          String spathrelajrprint = spathrelajasper;
          String spathrelapdf     = spathrelajasper;
          String spathrelaxls     = spathrelajasper;

          spathrelajrprint        = spathrelajrprint + sNomeRelJasper + ".jrprint";
          spathrelapdf            = spathrelapdf     + props.getProperty("PATHPDF") + sNomeRelJasper + ".pdf";
          spathrelaxls            = spathrelaxls     + props.getProperty("PATHXLS") + sNomeRelJasper + ".xls";

          String driver           = sdriver;
          String url              = surl;
          String user             = suser;
          String password         = spassword;

          Class.forName(driver);
          Connection conexao         = DriverManager.getConnection( url, user, password );

          Statement stm              = conexao.createStatement();
          sQuery                     = props.getProperty("PATHQUERY") + sQuery;
	  String query               = carregar( sQuery );
          ResultSet rs               = stm.executeQuery( query );
          
          JRResultSetDataSource jrRS = new JRResultSetDataSource( rs );
          HashMap map                = new HashMap();

          spathrelajasper            = spathrelajasper + sNomeRelJasper + ".jasper";

          JasperPrint print          = JasperFillManager.fillReport( spathrelajasper, map, jrRS );

          if (iModExbRel == 1)
          { JasperViewer viewer = new JasperViewer(print, false);
            viewer.setIconImage( Toolkit.getDefaultToolkit().getImage( spathiconeview ) );
            viewer.setTitle(stituloview);
            viewer.setExtendedState( JasperViewer.MAXIMIZED_BOTH );
            viewer.setDefaultCloseOperation( JasperViewer.EXIT_ON_CLOSE );
            viewer.setZoomRatio(10000.0F / 10000);
            viewer.setVisible(true); }
          else if (iModExbRel == 2)
               { JasperExportManager.exportReportToPdfFile( print, spathrelapdf );
                 if (iExecShell == 1)
                 { Runtime.getRuntime().exec("rundll32.exe Shell32.dll, ShellExec_RunDLL " + spathrelapdf); }
               }
          else if (iModExbRel == 3)
               { geraRelatorioExcel( print, spathrelaxls );
                 if (iExecShell == 1)
                 { Runtime.getRuntime().exec("rundll32.exe Shell32.dll, ShellExec_RunDLL "+spathrelaxls); }
               }

        }
        catch (SQLException e) {}

        }
        catch (NullPointerException e) {}
    }

public static String carregar(String arquivo)
throws FileNotFoundException, IOException {

File file = new File(arquivo);

if (! file.exists()) {
return null;
}

BufferedReader br = new BufferedReader(new FileReader(arquivo));
StringBuilder bufSaida = new StringBuilder();

String linha;
while( (linha = br.readLine()) != null )
{
 bufSaida.append(linha).append("\n");
}
br.close();
return bufSaida.toString();
}

private void geraRelatorioExcel( JasperPrint filled, String caminho )
throws FileNotFoundException, JRException, IOException
  {
    OutputStream output             = new FileOutputStream(new File(caminho));
    ByteArrayOutputStream xlsReport = new ByteArrayOutputStream();
    byte bytes[]                    = new byte[10];
    JRXlsExporter exporterXLS       = new JRXlsExporter();

    exporterXLS.setParameter(JRXlsExporterParameter.JASPER_PRINT                      , filled);
    exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_STREAM                     , xlsReport);
    exporterXLS.setParameter(JRXlsExporterParameter.OUTPUT_FILE                       , caminho);
    exporterXLS.setParameter(JRXlsExporterParameter.IS_ONE_PAGE_PER_SHEET             , Boolean.FALSE);
    exporterXLS.setParameter(JRXlsExporterParameter.IS_WHITE_PAGE_BACKGROUND          , Boolean.TRUE);
    exporterXLS.setParameter(JRXlsExporterParameter.IS_REMOVE_EMPTY_SPACE_BETWEEN_ROWS, Boolean.TRUE);
    exporterXLS.exportReport();

    bytes = xlsReport.toByteArray();
    xlsReport.close();

    output.write( bytes, 0, bytes.length );
    output.flush();
    output.close();
  }

}
