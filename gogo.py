#!/bin/env python3

# Gogo - A Python script to generate GDScript documentation.

from argparse import ArgumentParser as ArgParser
from pathlib import Path
import os, json, webbrowser


def parse(script_file):

    lines = script_file.readlines()

    class_attrs = {
        "info": [],
        "properties": [],
        "methods": [],
    }


    def add_attr(kind, name, start, end):

        if name:
            class_attrs[kind].append({
                "name": name,
                "description": "".join(
                    map( (lambda a : a[1:]), lines[start:end] )
                ).strip(),
            })
        else:
            class_attrs[kind].append({
                "description": "".join(
                    map( (lambda a : a[1:]), lines[start:end] )
                ).strip(),
            })


    i = 0
    while i < len(lines):

        if lines[i].startswith("#"):

            comment_end = i
            while comment_end < len(lines) - 1:
                comment_end += 1
                if not lines[comment_end].startswith("#"):
                    break

            if lines[comment_end].startswith("var"):
                attr_name = (lines[comment_end]
                             .split("var ")[1]
                             .split("=")[0]
                             .split(":")[0]
                             .strip())
                add_attr("properties", attr_name, i, comment_end)
            elif lines[comment_end].startswith("const"):
                attr_name = (lines[comment_end]
                             .split("const ")[1]
                             .split("=")[0]
                             .split(":")[0]
                             .strip())
                add_attr("properties", attr_name, i, comment_end)
            elif lines[comment_end].startswith("func"):
                attr_name = lines[comment_end].split("func ")[1].strip()[:-1]
                add_attr("methods", attr_name, i, comment_end)
            else:
                add_attr("info", "", i, comment_end)

            i = comment_end

        i += 1

    return class_attrs


def docify(project_name, name, attrs):

    class_desc = "<br>".join([i["description"] for i in attrs["info"]])

    plist = ("<ul>" +
             "<br>\n".join([
                 f"<li><code> {p['name']} </code></li>"
                 for p in attrs["properties"]]) +
             "</ul>")

    mlist = ("<ul>" +
             "<br>\n".join([
                 f"<li><code> {m['name']} </code></li>"
                 for m in attrs["methods"]]) +
             "</ul>")

    pdesc = ("<ul>" +
             "<br>\n".join([
                 f"<li><code> {p['name']} </code><br>\n{p['description']}</li>"
                 for p in attrs["properties"]]) +
             "</ul>")

    mdesc = ("<ul>" +
             "<br>\n".join([
                 f"<li><code> {m['name']} </code><br>\n{m['description']}</li>"
                 for m in attrs["methods"]]) +
             "</ul>")

    return f'''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title> {project_name} - {name} </title>
</head>
<body>
<h1><code> {name} </code></h1>
<h6> generated by gogo </h6>

<h2> Description </h2>
{class_desc}

<h2> Properties </h2>
{plist}

<h2> Methods </h2>
{mlist}

<h2> Property Descriptions </h2>
{pdesc}

<h2> Method Descriptions </h2>
{mdesc}

</body>
</html>
'''.strip()


def make_index(project_name, scripts):

    contents = "\n".join([
        f"<li><code><a href={s}.html>{s}</a></code></li>"
        for s in scripts
    ])

    return f'''
<!DOCTYPE html>
<html lang="en">
<head>
<meta charset="utf-8" />
<title> {project_name} - Contents </title>
</head>
<body>
<h1> {project_name} </h1>
<h6> generated by gogo </h6>
{contents}
</body>
</html>
'''.strip()


def make_docs(project_name, target_dir, source_dir):

    gd_files = source_dir.glob("**/*.gd")

    scripts = []

    print("Processing files...")

    for f in gd_files:
        print("\t", f)
        with open(f) as script_file:
            attrs = parse(script_file)
            stem = Path(f).stem

            scripts.append(stem)
            doc_content = docify(project_name, stem, attrs)

            if not target_dir.is_dir():
                target_dir.mkdir(parents=True, exist_ok=True)

            doc_filename = Path(target_dir, stem + ".html")

            with open(doc_filename, "w") as doc_file:
                doc_file.write(doc_content)


    index_filename = Path(str(target_dir), "index.html")

    index_content = make_index(project_name, scripts)

    with open(index_filename, "w") as index_file:
        index_file.write(index_content)


if __name__ == "__main__":

    parser = ArgParser(description="Generate GDScript documentation.")
    parser.add_argument(
        "-n", "--name", metavar="name", required=False,
        default="[Project]",
        help="The project name."
    )
    parser.add_argument(
        "-t", "--target", metavar="target", required=False,
        type=Path, default=Path("docs", "gogo"),
        help="The target documentation directory."
    )
    parser.add_argument(
        "-s", "--source", metavar="source", required=False,
        type=Path, default=Path("src"),
        help="The directory to search for GDScript source files."
    )
    parser.add_argument(
        "-o", "--open-in-browser", required=False, action="store_true",
        help="Open documentation in browser after building."
    )

    args = parser.parse_args()

    make_docs(args.name, args.target, args.source)

    if args.open_in_browser:
        webbrowser.open_new_tab(str(Path("file://",
                                         os.getcwd(),
                                         str(args.target),
                                         "index.html")))
