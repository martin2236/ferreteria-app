import 'dart:io';


class ImagePlugin{
  
  Future<String> guardarImagen(String carpeta, String filepath) async {
    // Definir el directorio base
    final Directory baseDir = Directory('./images/$carpeta');
    
    // Verificar si la carpeta existe; si no, crearla
    if (!await baseDir.exists()) {
      await baseDir.create(recursive: true);
    }

  
    if (filepath != '') {
      
      final path = Uri.parse(filepath).toFilePath();
      final components = path.split('\\');
      final File file = File(path);
      final String fileName = components.last;
      final String timestamp = DateTime.now().millisecondsSinceEpoch.toString(); // Obtener timestamp
      
      // Crear la ruta de destino dentro de la carpeta específica con timestamp
      final String destinationPath = '${baseDir.path}/$timestamp$fileName';
      
      // Copiar la imagen al directorio correspondiente
      await file.copy(destinationPath);
     
  return destinationPath;
   
    } else {
      print('No se seleccionó ninguna imagen');
      return '';
    }
  }
}
